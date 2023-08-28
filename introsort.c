/* 
  C file which contains various algorithms (heapify, heapsort, ...)
  that you must implement in beta assembly.
*/

void swap(int* a, int* b) {
  int tmp = *a;
  *a = *b;
  *b = tmp;
}

void heapify(int* array, int size, int index) {
  while (index < size) {
    int largest = index;
    int left = index * 2 + 1, right = (index + 1) * 2; 
    if (left < size && array[largest] < array[left]) {
      largest = left;
    } 
    if (right < size && array[largest] < array[right]) {
      largest = right;
    }
    if (largest != index) {
      swap(array + largest, array + index);
      index = largest;
    } else {
      break;
    }
  }
}

void heapsort(int* array, int size) {
  for (int i = (size / 2) - 1; i >= 0; --i) {
    heapify(array, size, i);
  }
  for (int i = size - 1; i > 0; --i) {
    swap(array, array + i);
    heapify(array, i, 0);
  }
}

int median3(int* array, int n) {
  int a = array[0], b = array[n / 2], c = array[n - 1];
  if (a < b) {
    if (b < c) {
      return b;
    } else if (a < c) {
      return c;
    } else {
      return a;
    }
  } else if (b < c) {
    if (a < c) {
      return a;
    } else {
      return c;
    }
  } else {
    return b;
  }
}

void introsort(int* array, int n, int maxd) {
  while (n > 1) {
    if (maxd <= 0) {
      heapsort(array, n);
      return;
    }
    maxd -= 1;
    int pivot = median3(array, n);

    // Three-way partition.
    int i = 0, l = 0, r = n;
    while (i < r) {
      if (array[i] < pivot) {
        swap(array + i, array + l);
        i += 1;
        l += 1;
      } else if (array[i] > pivot) {
        r -= 1;
        swap(array + i, array + r);
      } else {
        i += 1;
      }
    }
    introsort(array, l, maxd);
    array += r;
    n -= r;
  } 
}

void sort(int* array, int size) {
  if (size == 0) {
    return;
  }
  int maxd = 2 * (int)log2(size);
  introsort(array, size, maxd);
}